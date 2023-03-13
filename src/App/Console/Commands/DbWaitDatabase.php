<?php

declare(strict_types=1);

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Database\ConnectionInterface;
use Illuminate\Database\QueryException;

class DbWaitDatabase extends Command
{
    /**
     * The initial wait time for the first retry attempt.
     */
    private const INITIAL_WAIT_TIME = 1;

    /**
     * The maximum number of seconds to wait for the database to become available.
     */
    private const MAX_WAIT_TIME = 120;

    /**
     * Wait sleep time for db connection in seconds.
     */
    private const WAIT_SLEEP_TIME = 2;

    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'db:wait';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Waits for database availability.';

    /**
     * Execute the console command.
     */
    public function handle(ConnectionInterface $database): int
    {
        $waitTime = self::INITIAL_WAIT_TIME;

        for ($i = 0; $i < self::MAX_WAIT_TIME; $i += $waitTime) {
            try {
                $database->select('SHOW TABLES');
                $this->info('Connection to the database is ok!');

                return 0;
            } catch (QueryException $exception) {
                $this->comment('Trying to connect to the database seconds:' . $i);

                // Calculate the next wait time using exponential backoff.
                $waitTime *= 2;
                $waitTime = min($waitTime, self::WAIT_SLEEP_TIME);

                sleep($waitTime);
            }
        }

        $this->error('Can not connect to the database');

        return 1;
    }
}
