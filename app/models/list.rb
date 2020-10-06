class List < ActiveRecord::Base
    belongs_to :user
    has_many :items

    validates :name, presence: :true

    def ordered_items
        self.items.order(ranking: :desc)
    end

end
