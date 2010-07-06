module DB
  module Core
    module BPluss
      class Tree

        attr_reader :root_node

        def initialize(order=3)
          raise "Order less than 3 is not good for bpluss tree" if(order<3)
          @order=order
          @root_node=LeafNode.new(@order)
        end

        def insert(key, value)
          @root_node.insert(key, value)
          @root_node = @root_node.parent_node unless @root_node.parent_node.nil?
        end

        def search(key)
          @root_node.search(key)          
        end

      end
    end
  end
end