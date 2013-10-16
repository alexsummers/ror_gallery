class Category < ActiveRecord::Base

  attr_accessible :title, :title_locale, :translations
  translates :title_locale

  has_many :included_pictures, class_name: 'Picture', limit: 3, order: 'RANDOM()'
  has_many :pictures, dependent: :destroy
  has_many :category_subscriptions, dependent: :destroy
  has_many :users, through: :category_subscriptions

  validates :title, presence: true, length: {minimum: 1, maximum: 255}, uniqueness: true

  active_admin_translates :title_locale

  def title_loc
    if title_locale(I18n.locale).blank?
      return title
    end
    return title_locale(I18n.locale)
  end

end