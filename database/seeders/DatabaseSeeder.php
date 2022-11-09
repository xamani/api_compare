<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        // \App\Models\User::factory(10)->create();

        $users = User::factory(3)->create();
        $posts = Post::factory(3)->make()->each(function($post) use ($users) {
            $post->user_id = $users->random()->id;
        });
        Comment::factory(3)->make()->each(function ($comment) use ($users, $posts){
            $comment->user_id = $users->random()->id;
            $comment->post_id = $posts->random()->id;
        });
    }
}
