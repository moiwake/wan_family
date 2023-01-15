class PreNextBlobHash
  class << self
    attr_reader :previous_blob, :next_blob

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

      pre_next_blob_hash = { previous_blob: previous_blob, next_blob: next_blob}
    end

    private

    def when_desc_oder(blobs, base_blob)
      @previous_blob = blobs.where('created_at >= ? and id > ?', base_blob.created_at, base_blob.id).reverse.first
      @next_blob = blobs.where('created_at <= ? and id < ?', base_blob.created_at, base_blob.id).first
    end

    def when_asc_oder(blobs, base_blob)
      @previous_blob = blobs.where('created_at <= ? and id < ?', base_blob.created_at, base_blob.id).reverse.first
      @next_blob = blobs.where('created_at >= ? and id > ?', base_blob.created_at, base_blob.id).first
    end

    def when_likes_order(blobs, base_blob)
      base_blob_index = blobs.index(base_blob)
      @previous_blob = (base_blob != blobs.first) ? blobs[base_blob_index - 1] : nil
      @next_blob = (base_blob != blobs.last) ? blobs[base_blob_index + 1] : nil
    end
  end
end
