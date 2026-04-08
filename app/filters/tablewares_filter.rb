class TablewaresFilter
  attr_reader :relation, :params

  def initialize(relation = Tableware.all, params = {})
    @relation = relation
    @params = params
  end

  def call
    filtered = relation
    if params[:name].present?
      filtered = filtered.where("tablewares.name LIKE ?", "%#{params[:name]}%")
    end

    ids = Array(params[:category_item_ids]).reject(&:blank?).map(&:to_i)
    ids.each do |id|
      filtered = filtered.where_exists(:tableware_categories, category_item_id: id)
    end

    place_ids = Array(params[:place_ids]).reject(&:blank?).map(&:to_i)
    if place_ids.any?
      filtered = filtered.where_exists(:tableware_places, place_id: place_ids)
    end

    filtered
  end
end
