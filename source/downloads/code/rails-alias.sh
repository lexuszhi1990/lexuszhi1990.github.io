# rails
alias pro='RAILS_ENV=production'
alias bi="bundle install"
alias be="bundle exec"
alias rs="be rails s"
alias brs="be rspec"

# tool tips
alias g-s="grunt server --force"
alias bo="bundle open"
alias boi="bower install"
alias zs="zeus start"
alias zc="zeus c"
alias rc="be rails c"

# rails gegerators
alias rg="be rails g"
alias rails-g-migration="rg migration"
alias rails-g-controller='rg controller'
alias rails-g-model='rg model'
alias rails-g-scaffold='rg scaffold'

# rake tasks
alias re="be rake"
alias rr="be rake routes"
alias rake-migrate="re db:migrate"
alias rake-migrate-redo="re db:migrate:redo"
alias rake-rollback="re db:rollback"
alias rake-create="re db:create"
alias rake-drop="re db:drop"
alias rake-seed-fu="re db:seed_fu"
alias rake-time-zones="re time:zones:all"
alias rake-assets-precomplie="RAILS_ENV=production rake assets:precompile"
alias rake-assets-clean="rake assets:clean"

# backbone generators
alias backbone-model="rg backbone:model"
alias backbone-router="rg backbone:router"
alias backbone-scaffold="rg backbone:scaffold"

# rails servers
alias 3rs="rs 3000"
alias 4rs="rs 4000"
