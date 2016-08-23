if Rails.env.development?
  Rails.application.config.assets.precompile += %w( theme_kit.css theme_kit.js theme_kit/missing.png )
end
