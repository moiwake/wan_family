module SpotsHelper
  def display_area_search_form(form)
    if @prefecture_hash.present?
      tag.div(form.label :address_cont, "都道府県で絞る") +
      tag.div(form.select :address_cont, @prefecture_hash, include_blank: "選択してください")
    end
  end
end
