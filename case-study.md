# Case Study: Optimizing Test Suite and Collecting DX Metrics

## Introduction
In this case study, we optimize a Ruby test suite and collect Developer Experience (DX) metrics using InfluxDB, Grafana, Telegraf, and Chronograf.

## Steps Taken

### Environment Setup
1. Created a new Ruby project.
2. Installed necessary gems: RSpec, Test-Prof, Influxer, Guard, etc.

### Configuration
1. Initialized RSpec and Test-Prof.
2. Configured logging to reduce noise during tests.

### Sample Test Suite
1. Created a simple Ruby class `Sample` with a method `hello`.
2. Wrote corresponding tests using RSpec.

### Test Suite Optimization
1. Applied logging configuration to minimize log output during tests.
2. Used Test-Prof for sampling and profiling to identify and address bottlenecks.
````
SAMPLE=10 rspec
SAMPLE_GROUP=10 rspec
SAMPLE=10 TEST_RUBY_PROF=1 rspec
````

### DX Metrics Collection
1. Set up InfluxDB, Grafana, Telegraf, and Chronograf from scratch in docker-compose.yml
2. Integrated Influxer to collect and send test suite execution time to InfluxDB.
3. Created a dashboard in Chronograf to visualize the metrics.
````
SELECT "duration" FROM "dx_metrics"."autogen"."test_suite" WHERE time > :dashboardTime: AND time < :upperDashboardTime:
````

## Results
1. The test suite's execution time was reduced by optimizing identified bottlenecks.
2. DX metrics were successfully collected and visualized, providing insights into test suite performance.

### Conclusion
By following these steps, we optimized the test suite and set up a system for ongoing DX metrics collection to prevent regression and ensure continuous improvement.

### Screenshots
![Chronograf Dashboard](https://github.com/zoopyserg/rails-optimization-task7/assets/1587149/36ae4ccd-0867-44ae-a636-a9ace0041bfa)


# Lecture Notes

## Optimization of Development Experience
- Fast feedback loop
- DX metrics
- Test suite optimization
- Frontend DX optimization
- Asset precompilation optimization
- CI optimization

## Ruby DX
- Auto reloading
- Instant test runs (e.g. in C++ one has to precompile a lot)

## Feedback loop speed
1 min feedback loop = 480 iterations per day
10 min feedback loop = 48 iterations per day + distractions

## App Startup Time
- Spring (first run 15sec, next run 1.5sec, once per week 30min debugging)
- Bootsnap (5sec boot time) - **preferrable option**
- Proprietary or paid tools (not open source) - skip no matter what.

## Debugging tools
- Pry
- Byebug (preferrable due to stability)

## Test suite optimization
- Most rails projects have 20-60-minute test suites
- Minitest is not faster than RSpec
- Guard (auto-run tests) + terminal-notifier-guard (notifications)
- DX metrics collection + InfluxDB + Grafana + Telegraf + Chronograf + DX Dashboard + Gem Influxer
- Parallel tests (tried, does not always work on CI)
- Developer Acceleration Team (a sub-team of devs that work on DX)

## Actual optimization

### Logging
Turn off logging in test environment.
````
config.logger = Logger.new(nil)
config.log_level = :fatal
````

### Uploads
Upload only once for all tests.
E.g. don't create images in factories, etc.
Only when you actually need to test uploads.
Clear public uploads, logs, tmp, and rerun tests.

### Mailers
Don't send emails in tests unless you need to test email sending.

### Background Jobs
Don't run background jobs in tests unless you need to test background jobs.

### rspec --profile
- Shows slowest tests

### test-prof

#### Sampling
(part of test-prof)
````
SAMPLE=10 rspec
SAMPLE_GROUP=10 rspec
````

#### Stackprof + Flamegraph + Speedscope
(part of test-prof, for details see homework 1)

#### Ruby-Prof + qcachegrind
(part of test-prof, for details see homework 2)
````
SAMPLE=10 TEST_RUBY_PROF=1 rspec
````

#### rspec dissect
(part of test-prof, for details see homework 3)
````
RD_PROF=1 rspec
````

#### Transactinoal tests
Time consuming
````
before(:all) + after(:all) + before(:each) + after(:each)
````

Better to use `before_all` and `let_it_be` (part of test-prof)

#### Factory Prof
(part of test-prof)
````
FPROF=1 rspec
````

#### Jobs prof
(part of test-prof)
````
EVENT_PROF=sidekiq.inline rspec
````

#### Event Prof
(part of test-prof)
````
EVENT_PROF='sql.active_record' rspec
````
It can also automatically set tags:
````
EVENT_PROF_STAMP=:slow:first rspec
````

#### Tag Prof
(part of test-prof)
Diagram which tests take how much time.

#### Factory Doctor
Don't always do `create :factory``
There are `build_stubbed` and `build` methods that are faster.

This command will highlight where create can be replaced with build_stubbed:
````
FDOC=1 rspec
````

#### Use less secure encryption for tests

### Database Cleaner
Not applicable in tests with multiple threads.

### Coverage
- Pronto + Undercover

### Knapsack
- Parallel tests (better in some cases than parallel_tests gem)

### Front end optimization
- Live Reload
- Aim instant feedback loop

#### Guard LiveReload
````
gem 'guard-livereload', require: false
````

#### Local Production
````
config.assets.debug = false
config.assets.js_compressor = :uglifier
config.assets.digest = true
config.browserify_rails.source_map_environments = []
config.browserify_rails.use_browserifyinc = false
config.react.variant = :production
config.browserify_rails.node_bin = :production
````

rails-sass -> rails-sassc
call uglifyer through nodejs
etc
many tricks to optimize asset precompile.

**Always optimize the main point of growth.**

### CI optimization
- Cache builds (so that bundle, yarn, bootsnap, webpacker, etc components are taken from cache if versions didn't change)
- Fail fast
