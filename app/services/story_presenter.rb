class StoryPresenter < SimpleDelegator
  def title
    model.title.present? ? sanitized_title : sanitized_message
  end

  private

  def sanitized_title
    with_full_stop model.title.strip
  end

  def sanitized_message
    with_full_stop model.message.
      split(/\n+/).first.strip.
      gsub(/.* into /, '').
      gsub(/\d+$/, '').strip
  end

  def with_full_stop str
    str.end_with?('.') ? str : "#{str}."
  end

  def model
    __getobj__
  end
end
