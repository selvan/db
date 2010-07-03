module DB
  module Core
    module BPluss
      class InternalNode
        attr_reader :infinity_node, :keys_and_node_pointers
        attr_accessor :parent_node

        def initialize(order=3, infinity_node=nil)
          @order=order
          @max_capacity=@order-1
          @keys_and_node_pointers=[]
          @infinity_node=infinity_node
          @infinity_node.parent_node=self
          @parent_node=nil
        end

        def keys
          keys=[]
          @keys_and_node_pointers.each {|key_data| keys << key_data[0]}
          keys
        end

        def max_key_value
          @keys_and_node_pointers[-1][0]
        end

        def insert_node_pointer(key_and_node)
          key_and_node[1].parent_node=self
          @keys_and_node_pointers << key_and_node
          sort_keys
          split if @keys_and_node_pointers.size > @max_capacity
        end

        def insert(key, value)
          case
            when key > max_key_value
              @infinity_node.insert(key, value)
            else
              @keys_and_node_pointers.each do |key_node|
                if key <= key_node[0]
                  key_node[1].insert(key, value)
                  break;
                end
              end
          end
        end

        private
        def sort_keys
          @keys_and_node_pointers.sort! {|a, b| a[0]<=>b[0]}
        end

        def split
          split_index=((@keys_and_node_pointers.length / @max_capacity.to_f).ceil)-1
          splited_values=@keys_and_node_pointers.values_at(0..split_index)
          @keys_and_node_pointers.slice!(0..split_index)

          max_key_node = splited_values[-1]

          new_node=InternalNode.new(@order, max_key_node[1])

          @parent_node = InternalNode.new(@order, self) if @parent_node.nil?
          new_node.parent_node=@parent_node

          splited_values.slice!(-1)
          splited_values.each {|key_node| new_node.insert_node_pointer(key_node) }

          @parent_node.insert_node_pointer([max_key_node[0], new_node])

        end
      end
    end
  end
end
