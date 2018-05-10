class Admin::BaseController < ApplicationController
  def self.local_prefixes
    [controller_path, controller_path.sub(/^admin\//, ''), controller_path]
  end
end
