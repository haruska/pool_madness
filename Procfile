web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
all_worker: bundle exec sidekiq -e production -c 5 -q default -q mailers -q elimination -q scores
elimination: bundle exec sidekiq -e production -c 5 -q elimination
fast: bundle exec sidekiq -e production -c 5 -q default -q mailers -q scores