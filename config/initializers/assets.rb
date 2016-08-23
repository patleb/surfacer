if Rails.env.development?
  Rails.application.config.assets.precompile += %w( theme_kit.css )
end
