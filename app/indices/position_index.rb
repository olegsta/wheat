config =  {
            :with => :active_record,
            :delta => true
          }

ThinkingSphinx::Index.define :position, config do
  indexes index_field
  where "status = 'opened'"
end