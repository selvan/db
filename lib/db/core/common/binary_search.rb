module DB
  module Core
    module Common
      def self.binary_search(arr, search_term, low, high, &block)
        return nil if (high < low) # not found
        mid = low + ((high - low) / 2)
        value = block_given? ? yield(arr[mid]) : arr[mid]
        if (value > search_term)
          return binary_search(arr, search_term, low, mid-1, &block)
        elsif (value < search_term)
          return binary_search(arr, search_term, mid+1, high, &block)
        else
          return arr[mid]
        end
      end
    end
  end
end