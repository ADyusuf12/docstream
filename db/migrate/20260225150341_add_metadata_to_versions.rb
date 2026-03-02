class AddMetadataToVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :versions, :metadata, :text
  end
end
