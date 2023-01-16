class PrevNextBlobHash
  class << self
    attr_reader :prev_blob, :next_blob

    def call(base_blob: nil, blobs:, params: {})
      if params[:by] == "created_at" && params[:direction] == "desc"
        when_desc_oder(blobs, base_blob)
      elsif params[:by] == "created_at" && params[:direction] == "asc"
        when_asc_oder(blobs, base_blob)
      elsif params[:by] == "likes_count" && params[:direction] == "desc"
        when_likes_order(blobs, base_blob)
      else
        when_desc_oder(blobs, base_blob)
      end

      prev_next_blob_hash = { prev_blob: prev_blob, next_blob: next_blob}
    end

    private

    def when_desc_oder(blobs, base_blob)
      @prev_blob = search_record_created_after(blobs, base_blob).reverse.first
      @next_blob = search_record_created_before(blobs, base_blob).first
    end

    def when_asc_oder(blobs, base_blob)
      @prev_blob = search_record_created_before(blobs, base_blob).reverse.first
      @next_blob = search_record_created_after(blobs, base_blob).first
    end

    def when_likes_order(blobs, base_blob)
      base_blob_index = blobs.index(base_blob)
      @prev_blob = (base_blob != blobs.first) ? blobs[base_blob_index - 1] : nil
      @next_blob = (base_blob != blobs.last) ? blobs[base_blob_index + 1] : nil
    end

    def search_record_created_before(blobs, base_blob)
      blobs.where(
        'active_storage_blobs.created_at <= ? and active_storage_blobs.id < ?',
        base_blob.created_at,
        base_blob.id
      )
    end

    def search_record_created_after(blobs, base_blob)
      blobs.where(
        'active_storage_blobs.created_at >= ? and active_storage_blobs.id > ?',
        base_blob.created_at,
        base_blob.id
      )
    end
  end
end
