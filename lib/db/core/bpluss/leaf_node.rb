module DB
  module Core
    module BPluss
      class LeafNode

        attr_accessor :keys_and_data_pointers 
        attr_accessor :parent_node, :pre_node, :next_node

        def initialize(order=3, keys_and_datapointers=[])
          @order=order
          @max_capacity=@order-1
          @keys_and_data_pointers=keys_and_datapointers
          @pre_node=nil
          @next_node=nil
          @parent_node=nil
        end

        def keys
          keys=[]
          @keys_and_data_pointers.each {|key_data| keys << key_data[0]}
          keys
        end

        def max_key_value
          @keys_and_data_pointers[-1][0]
        end

        def key_exists?(key)
          DB::Core::Common.binary_search(@keys_and_data_pointers, key, 0, @keys_and_data_pointers.length-1) {|ele| ele[0]}
        end

        def insert(key, value)
          existing_node = key_exists?(key)
          case existing_node
            when nil
              _data = [] << key << value
              @keys_and_data_pointers << _data
              sort_keys
              split if @keys_and_data_pointers.size > @max_capacity
            else
              existing_node[1] = ([] << existing_node[1]) unless existing_node[1].instance_of?(Array)
              existing_node[1] << value
          end
        end

        def is_leaf_empty?
          @keys_and_data_pointers.size==0
        end

        private
        def sort_keys
          @keys_and_data_pointers.sort! {|a, b| a[0]<=>b[0]}
        end

        def split
          split_index=((@keys_and_data_pointers.length / @max_capacity.to_f).ceil)-1
          splited_values=@keys_and_data_pointers.values_at(0..split_index)
          @keys_and_data_pointers.slice!(0..split_index)

          new_node=LeafNode.new(@order, splited_values)
          new_node.pre_node = @pre_node
          new_node.next_node=self
          @pre_node=new_node

          @parent_node = InternalNode.new(@order, self) if @parent_node.nil?
          @pre_node.parent_node=@parent_node
          @parent_node.insert_node_pointer([@pre_node.max_key_value, @pre_node]) unless @parent_node.nil?
        end

      end
    end
  end
end