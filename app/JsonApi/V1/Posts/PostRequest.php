<?php

namespace App\JsonApi\V1\Posts;

use Illuminate\Validation\Rule;
use LaravelJsonApi\Laravel\Http\Requests\ResourceRequest;
use LaravelJsonApi\Validation\Rule as JsonApiRule;

class PostRequest extends ResourceRequest
{

    /**
     * Get the validation rules for the resource.
     *
     * @return array
     */
    public function rules(): array
    {
        return [
            "title" => ['required','string','min:3'],
            "body" => ['required','string','min:3'],
        ];
    }

}
