# deploy
alias cap-staging="cap staging deploy"
alias cap-staging-migrations="cap staging deploy:migrations"
alias cap-staging-rake="cap staging remote:rake"
alias cap-staging-console="cap staging remote:console"
alias cap-staging-database-update="cap staging update:database"
alias cap-staging-assets-update="cap staging update:shared_assets"
alias cap-staging-assets-remote-update="cap staging update:remote:shared_assets"
alias cap-staging-remote-tail-log='cap staging remote:tail_log'

alias cap-production="cap production deploy"
alias cap-production-migrations="cap production deploy:migrations"
alias cap-production-rake="cap production remote:rake"
alias cap-production-console="cap remote:console"
alias cap-production-database-update="cap production update:database"
alias cap-production-assets-update="cap production update:shared_assets"
alias cap-production-assets-remote-update="cap production update:remote:shared_assets"
alias cap-production-database-remote-update="cap production update_remote:database"
alias cap-production-remote-tail-log='cap production remote:tail_log'
