class AddPageToTags < ActiveRecord::Migration[5.2]
  def change
    add_reference :tags, :page
  end
end
