module DB
  module Core
    module BPluss
      class LeafNode

        attr_accessor :parent_node, :pre_node, :next_node

        def initialize(order=3, keys_and_datapointers=[])
          @order=order
          @max_capacity=@order-1
          @keys_and_datapointers=keys_and_datapointers
          @pre_node=nil
          @next_node=nil
          @parent_node=nil
        end

        def keys
          keys=[]
          @keys_and_datapointers.each {|key_data| keys << key_data[0]}
          keys
        end

        def max_key_value
          @keys_and_datapointers[-1][0]
        end

        def insert(key, value)
          case
            when @keys_and_datapointers.size  < @max_capacity
              _data = [] << key << value
              @keys_and_datapointers << _data
              sort_keys
            else
              #todo handle duplicate keys
              _data = [] << key << value
              @keys_and_datapointers << _data
              sort_keys
              split if @keys_and_datapointers.size > @max_capacity
          end
        end

        def is_leaf_empty?
          @keys_and_datapointers.size==0
        end

        private
        def sort_keys
          @keys_and_datapointers.sort! {|a, b| a[0]<=>b[0]}
        end

        def split
          split_index=((@keys_and_datapointers.length / @max_capacity.to_f).ceil)-1
          splited_values=@keys_and_datapointers.values_at(0..split_index)
          @keys_and_datapointers.slice!(0..split_index)

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