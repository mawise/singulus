# frozen_string_literal: true

# Provides helper methods to access Hugo GitHub repository.
module GitHubManipulator
  extend ActiveSupport::Concern

  protected

  def github
    @github ||= Octokit::Client.new(access_token: Rails.configuration.x.github.token)
  end

  def github_repo
    Rails.configuration.x.github.repo
  end

  def github_branch
    Rails.configuration.x.github.branch
  end
end
