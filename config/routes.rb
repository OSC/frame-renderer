Rails.application.routes.draw do
  resources :projects do
    resources :scripts do
      put 'submit'
      get 'jobs'
      delete '/jobs/:job_id' => 'scripts#stop', as: 'stop_job'
    end
  end

  root 'projects#index'
end
