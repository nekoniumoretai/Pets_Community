class User::RelationshipsController < ApplicationController
  before_action :authenticate_user!
end
