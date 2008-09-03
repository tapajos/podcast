ENV['SKIP_TASKS'] = %w( 
                         spec:lib
                         spec:models
                         spec:helpers
                         spec:controllers
                         spec:views
                         test:rcov:units:verify
                         test:rcov:functionals:verify
                         spec:rcov
                         spec:rcov:verify
                         test:selenium:server:start
                         test_acceptance
                         test:selenium:server:stop
                    ).join(',')
                    
ENV['SCM'] = 'git'

def integration_sweeper
  sh "script/integration_sweeper"
end

ENV['SCM'] = 'git'

namespace :scm do
  namespace :status do
    namespace :check do
      task :before do
        integration_sweeper
      end
    end
  end
end