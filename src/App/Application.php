<?php

namespace App;

use Illuminate\Foundation\Application as LaravelApplication;

class Application extends LaravelApplication
{
    protected $namespace = 'App\\';

    public function __construct($basePath = null)
    {
        parent::__construct($basePath);
        $this->useAppPath($basePath . DIRECTORY_SEPARATOR . 'src' . DIRECTORY_SEPARATOR . 'App');
    }
}
