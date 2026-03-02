class Version < ApplicationRecord
  belongs_to :document

  audited

  serialize :metadata, type: Hash, coder: YAML
end
