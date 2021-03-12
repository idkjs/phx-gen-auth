# TutorialAuth

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

# Step One

Generate boilerplate from https://fullstackphoenix.com/boilerplates

# Step 2

- setup some resources that should have some protected routes. Generate `products` resources by running:
- `mix phx.gen.pretty_html Products Product products name description:text price:float`
```sh
tutorial_auth on  main [!] via 💧 v1.11.2 took 51s 885ms
 [I] ➜ mix phx.gen.pretty_html Products Product products name description:text price:float

* creating lib/tutorial_auth_web/controllers/product_controller.ex
* creating lib/tutorial_auth_web/templates/product/edit.html.eex
* creating lib/tutorial_auth_web/templates/product/form.html.eex
* creating lib/tutorial_auth_web/templates/product/index.html.eex
* creating lib/tutorial_auth_web/templates/product/new.html.eex
* creating lib/tutorial_auth_web/templates/product/show.html.eex
* creating lib/tutorial_auth_web/views/product_view.ex
* creating test/tutorial_auth_web/controllers/product_controller_test.exs
* creating lib/tutorial_auth/products/product.ex
* creating priv/repo/migrations/20210111164720_create_products.exs
* creating lib/tutorial_auth/products.ex
* injecting lib/tutorial_auth/products.ex
* creating test/tutorial_auth/products_test.exs
* injecting test/tutorial_auth/products_test.exs

Add the resource to your browser scope in lib/tutorial_auth_web/router.ex:

    resources "/products", ProductController


Remember to update your repository by running migrations:

```

Add `resources "/products", ProductController` and configure private/public routes in `lib/tutorial_auth_web/router.ex`

see [diff](https://github.com/idkjs/phx-gen-auth/commit/059ac5729126219f042c8a32af35d1ffdd37d5a6#diff-a541bf4bf7baaa51ad5b1c45a7f2ece2c7975e1ba0504c68f96ee4d81608098a)

Then run `ecto.migrate`:
```sh
tutorial_auth on  main [!?] via 💧 v1.11.2
 [I] ➜ mix ecto.migrate
Compiling 1 file (.ex)
warning: this clause cannot match because a previous clause at line 23 always matches
  lib/tutorial_auth_web/router.ex:83

warning: TutorialAuthWeb.PageController.init/1 is undefined (module TutorialAuthWeb.PageController is not available or is yet to be defined)
  lib/tutorial_auth_web/router.ex:83: TutorialAuthWeb.Router.__checks__/0

Generated tutorial_auth app

17:54:44.332 [info]  == Running 20210111164720 TutorialAuth.Repo.Migrations.CreateProducts.change/0 forward

17:54:44.341 [info]  create table products

17:54:44.399 [info]  == Migrated 20210111164720 in 0.0s

tutorial_auth on  main [!?] via 💧 v1.11.2
 [I] ➜

```

# Step 3 - Update tests

If I run the tests now, I will get some failing controller tests. That is because some of the routes are private and we need to make sure we run them as an authenticated user.

Open the test file for [product_controller_test.exs](test/tutorial_auth_web/controllers/product_controller_test.exs) and add a `setup` before the first `describe` block. Then run `mix test`. All tests should pass.

```sh
 setup :register_and_log_in_user
```

Running the tests will pass now:

```sh
Generated tutorial_auth app
........................................................................................................................

Finished in 33.8 seconds
120 tests, 0 failures

Randomized with seed 720355
```

The function `register_and_log_in_user` is added through ConnCase when phx_gen_auth was installed.

# Step 4 - Install Guardian

[Guardian](https://hex.pm/packages/guardian) is a token based authentication library for use with Elixir applications. It defaults to use Json Web Tokens but you can user other standards. You can use it for both endpoint authentication but also web sockets. The installation is pretty straight forward, and I am following the [Github guide](https://github.com/ueberauth/guardian).

- add it to `mix.exs` the run `mix deps.get`
```iex
{:guardian, "~> 2.1"}
```

Next, we need to add our own Guardian implementation module. I can use it for customization in my app but I will just go with the default:

- create a file call `guardian.ex` in [lib/tutorial_auth_web](lib/tutorial_auth_web) and add the following to it:

```sh
> touch lib/tutorial_auth_web/guardian.ex
echo "defmodule TutorialAuthWeb.Guardian do
   use Guardian, otp_app: :tutorial

   alias TutorialAuthWeb.Accounts

   def subject_for_token(resource, _claims) do
     sub = to_string(resource.id)
     {:ok, sub}
   end

   def resource_from_claims(claims) do
     id = claims["sub"]
     resource = Accounts.get_user!(id)
     {:ok,  resource}
   end
 end" > lib/tutorial_auth_web/guardian.ex
```

Configure my Guardian with my a secret key and how long the json web token is valid in [config/config.exs](config/config.exs)

```powershell
#config/config.exs
config :tutorial_auth, TutorialAuth.Guardian,
    issuer: "tutorial",
    secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
    ttl: {3, :days}

 config :tutorial_auth, TutorialAuthWeb.AuthAccessPipeline,
    module: TutorialAuth.Guardian,
    error_handler: TutorialAuthWeb.AuthErrorHandler
```

Add configuration for authentication plugs:
```sh
# lib/tutorial_web/plugs/auth_access_pipeline.ex
defmodule TutorialAuthWeb.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :tutorial_auth

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
```

Specify a response when a user tries to access a restricted route:

```sh
# lib/tutorial_auth_web/plugs/auth_error_handler.ex
defmodule TutorialAuthWeb.AuthErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end
```
Next in this step is to add two changes to the routes file. First a pipeline for when we have restricted api endpoints. And then, inside the api block, I need a route to an api/sessions controller so we can authenticate and get an api token:
```sh

# lib/tutorial_auth_web/router.ex
defmodule TutorialAuthWeb.Router do
  use TutorialAuthWeb, :router

  ...Other code

  pipeline :api_authenticated do
    plug TutorialAuthWeb.AuthAccessPipeline
  end

  scope "/api", TutorialAuthWeb.Api, as: :api do
    pipe_through :api

    post "/sign_in", SessionController, :create
  end
end
```

# Step 5 - Add Api endpoints for products

We have already made an html scaffold for products but there is yet no api. So I need to add api routes to the routes. And same as before, I want index and show to be public routes. Create, Update and delete should require an authenticated user.
```sh
# lib/tutorial_web/router.ex
scope "/api", TutorialWeb.Api, as: :api do
  pipe_through :api

  post "/sign_in", SessionController, :create # Added before
  resources "/products", ProductController, only: [:index, :show]
end
```

```
## Authentication api routes
scope "/api", GraphqlTutorialWeb.Api, as: :api do
  pipe_through :api_authenticated

  resources "/products", ProductController, except: [:index, :show]
end
```
# Resources
https://www.viget.com/articles/getting-started-with-graphql-phoenix-and-react/
https://crypt.codemancers.com/posts/2020-03-16-a-full-stack-guide-to-graphql-elixir_phoenix_server/


