<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

//Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//    return $request->user();
//});
Route::resource('users', \App\Http\Controllers\UserController::class);

\LaravelJsonApi\Laravel\Facades\JsonApiRoute::server('v1')
    ->prefix('v1')
    ->withoutMiddleware('jsonapi')
    ->namespace('App\Http\Controllers\Api\V1')
    ->resources(function ($server) {

        $server->resource('users')
            ->parameter('id')
            ->relationships(function ($relationships) {
                $relationships->hasMany('posts');
            });

        $server->resource('posts')
            ->parameter('id')
            ->relationships(function ($relationships) {
                $relationships->hasMany('comments');
            });

    });
