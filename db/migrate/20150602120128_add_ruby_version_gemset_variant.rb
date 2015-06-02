class AddRubyVersionGemsetVariant < ActiveRecord::Migration
  def change
    add_column :projects, :ruby_version, :string
    add_column :projects, :ruby_gemset, :string
    add_column :projects, :build_variant, :string
    add_column :projects, :git_repo, :string
    add_column :projects, :git_branch, :string
  end
end
