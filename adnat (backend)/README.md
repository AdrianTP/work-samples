# adnat (backend)
Read the [REQUIREMENTS](REQUIREMENTS.md) to understand what I'm trying to
accomplish here.

## How to Run This
1. Install Ruby 2.7.1
2. Install Bundler > 2.1
3. `./bin/setup`
4. Use Postman or something to interact with the API

I also included this barebones [Postman collection](adnat.postman_collection.json)
for convenience, though it is from early on while I was still puzzling out the
API structure, thus it lacks a few endpoints and does not have auth implemented.

## Notes
I initialised this Rails 6.0 app as API-only, and I disabled a bunch of unused
functionality that came bundled with it.

I namespaced the routes and their controllers under `/api/`.

Rails 6.0 with rspec-rails uses a different testing structure than I am used to;
it has specs for the routing (spec/routing/api), and specs for requests
(spec/requests/api).

Tests are very unfinished, just like the API functionality. I wanted to polish
this up, but I feel like I already spent too much time on this. Sorry!

## Tasks
- [ ] API
  - [ ] Sessionless stateless token-based User authentication and authorisation
  - [ ] Endpoints
    - [ ] Organisations
      - [ ] Core functionality
        - [x] List all Organisations
        - [x] View the details of an Organisation
        - [x] Create a new Organisation
        - [x] Edit the details of an existing Organisation
        - [x] List all Users associated with an Organisation
        - [ ] List all Shifts associated with an Organisation, grouped by User
          - [ ] Filter the list of Shifts
      - [x] Input validation
      - [ ] Specs
    - [ ] Users
      - [ ] Core functionality
        - [x] List all Users
        - [x] View the details of a User
        - [x] Create a new User
        - [ ] Edit the details of a User
          - [ ] Each User may only edit their own details
        - [x] Mark a User as inactive
        - [ ] Reactivate a User
        - [x] List all Organisations with which this User is associated
        - [x] Associate a User with an Organisation
        - [x] Remove the association between a User and an Organisation
        - [ ] List all Shifts associated with a User, grouped by Organisation
        - [ ] Create a new Shift associated with a User and an Organisation
          - [ ] Include Breaks within the Shift
      - [ ] Input validation
      - [ ] Specs
    - [ ] Shifts
      - [ ] Core functionality
        - [ ] View the details of a Shift
        - [ ] Edit the details of a Shift
          - [ ] Each User may only edit their own Shifts
        - [ ] Add a Break to a Shift
      - [ ] Input validation
      - [ ] Specs
  - [ ] Business logic
    - [ ] Shifts
      - [ ] Calculations
        - [ ] Hours worked
        - [ ] Shift cost
        - [ ] Overnight shifts
        - [ ] Sunday overtime
- [ ] Front-end SPA
  - [ ] Prompt login/signup for unathenticated visitors
  - [ ] Prompt Organisation selection for new Users

## Personal Whinging
I am submitting this solution in an unfinished state. I am about half-way
finished with the API, and I have yet to begin working on the front-end
application. I lost momentum while working on API input validation with
[Apipie-rails]() and on stateless (token-based) auth with [Knock](https://github.com/nsarno/knock).

Challenges I faced which affected my implementation:
- I have never created a Rails app completely from scratch before -- I have
  always worked within a provided boilerplate or added features to an existing
  fully-built production application.
- I used the newest version of Rails. This meant that the vast majority of
  documentation and examples I read about any gems I used were often not
  directly applicable to my specific situation. For example:
  - `bundle exec rails g apipie:install` (and any similar installation commands)
    would fail, meaning plenty of things didn't get set up correctly or
    completely.
  - Running `rails s` and navigating to `http://localhost:3000/apipie` to view
    the auto-generated API documentation (literally 90% of the reason I chose
    Apipie) failed with a `No route matches [GET] "/apipie"` error message,
    presumably because the installation script failed to run, which likely would
    have added the required route(s) and controller(s).
- Apipie does not support dependent parameters, but I did not realise that until
  I had already sunk significant time into learning the DSL and applying Apipie
  validations to my API endpoints. This complicates the `UPDATE /users/:user_id`
  endpoint validations, as it makes it impossible to use the same endpoint and
  the same validations to cover updating the user's password (if
  `current_password` is included, then `new_password` and
  `new_password_confirmation` should be required as well, otherwise all three
  fields should be optional).
- The documentation and examples I could find for Knock did not demonstrate the
  use case of API input validation, nor of updating an existing password.
- Rails' built-in validations often provided unhelpful error messages, hence the
  necessity of manually-implementing API input validation.
- I have leveraged JSON Schema successfully in the past, and I even wrote
  [my own documentation generator for it](https://github.com/AdrianTP/schemadoc)
  (private repo, please let me know if you want to see it, and I will share it
  with you), but the [json-schema](https://github.com/ruby-json-schema/json-schema)
  gem has not been updated in 2 years, only supports V4, barely supports
  hyperschema, and has several outstanding unresolved bugs. The alternative
  [json_schema](https://github.com/brandur/json_schema) gem is similarly
  outdated, and I have never used it.

The constant issues I faced, and the unusually large proportion of my time I
spent reading documentation and failing to get things working which were
supposed to "just work" led to me becoming disheartened and unwilling to
continue working on this project without feedback and support. If I had a team
from whom I could elicit support and guidance, things would be different. If I
had used an older version of Ruby and an older version of Rails, things may have
turned out better. In the end, I enjoyed the challenge, but it was taking up too
much of my time.
