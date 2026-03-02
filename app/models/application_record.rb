# frozen_string_literal: true

# Base class for all ActiveRecord models in the application.
# It inherits from ActiveRecord::Base and provides common functionality
# to all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
