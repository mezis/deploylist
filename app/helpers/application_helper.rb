module ApplicationHelper
  def github_diff_link(deploy)
    if deploy.previous && !deploy.missing_sha?
      link_to deploy.short_ref,
        Addressable::Template.new('https://www.github.com/{+repo}/compare/{old}...{new}').
        expand(
          repo: ENV['GITHUB_REPO'],
          old:  deploy.previous.short_ref,
          new:  deploy.short_ref
        ).to_s,
        title: 'View full diff'
    else
      deploy.short_ref
    end
  end

  def ticket_link(story)
    return unless story.ticket_uid
    link_to "[#{story.ticket_uid}]",
      Addressable::Template.new(ENV.fetch('TICKET_URL')).expand(
        uid: story.ticket_uid
      ).to_s,
      title: "Ticket"
  end

  def pull_request_link(story)
    link_to "##{story.pull_request_uid}",
      "https://www.github.com/#{ENV['GITHUB_REPO']}/pull/#{story.pull_request_uid}",
      title: "[##{story.pull_request_uid}]"
  end
end
