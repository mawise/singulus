# frozen_string_literal: true

# == Schema Information
#
# Table name: oauth_applications
#
#  id           :uuid             not null, primary key
#  confidential :boolean          default(TRUE), not null
#  name         :text             not null
#  redirect_uri :text
#  scopes       :text             default(""), not null
#  secret       :text             not null
#  uid          :text             not null
#  url          :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_oauth_applications_on_uid  (uid) UNIQUE
#  index_oauth_applications_on_url  (url) UNIQUE
#
require 'rails_helper'

# RSpec.describe Auth::Application, type: :model do
# end
