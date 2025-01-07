# frozen_string_literal: true

# When we migrated from Owens to Cardinal, the only version on
# Cardinal is 2025, so update all the records for the user
# as whatever version they have in the DB won't work.
Rails.application.config.after_initialize do
  Script.all.each do |script|
    if script.is_a?(MayaScript)
      script.version = '2025' if script.version.to_s < '2025'
      script.save
    end
  end
end
