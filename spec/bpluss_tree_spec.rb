require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe DB::Core::BPluss do

  it "should throw error when order is less than 3" do
    lambda { DB::Core::BPluss::Tree.new(2)}.should raise_error
  end

  ## These specs are modelled around content of notes/bpluss_tree.pdf ## 
  context "Insert" do

    before(:each) do
      @btree=DB::Core::BPluss::Tree.new(3)
    end


    it "Inserting Key Value 5" do
      @btree.insert(5, "Five");
      root_node=@btree.root_node
      root_node.should be_instance_of(DB::Core::BPluss::LeafNode)
      root_node.keys.should == [5]
    end

    it "Inserting Key Value 8" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      root_node=@btree.root_node
      root_node.should be_instance_of(DB::Core::BPluss::LeafNode)
      root_node.keys.should == [5, 8]
    end

    it "Inserting Key Value 1" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      @btree.insert(1, "One");
      root_node=@btree.root_node
      root_node.should be_instance_of(DB::Core::BPluss::InternalNode);
      root_node.keys.should == [5]
      right_most_node=root_node.infinity_node
      right_most_node.keys.should==[8]
      right_most_node.pre_node.keys.should==[1, 5]
      right_most_node.pre_node.parent_node.keys.should==[5]
    end

    it "Insert Key Value 7" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      @btree.insert(1, "One");
      @btree.insert(7, "One");
      root_node=@btree.root_node
      root_node.should be_instance_of(DB::Core::BPluss::InternalNode);
      right_most_node=root_node.infinity_node
      right_most_node.keys.should==[7, 8]

      right_most_node.pre_node.keys.should==[1, 5]
      right_most_node.pre_node.parent_node.keys.should==[5]
    end

    it "Insert Key Value 3" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      @btree.insert(1, "One");
      @btree.insert(7, "One");
      @btree.insert(3, "Three");
      root_node=@btree.root_node
      root_node.should be_instance_of(DB::Core::BPluss::InternalNode);

      root_node.keys.should == [3, 5]

      right_most_node = root_node.infinity_node
      right_most_node.keys.should == [7, 8]

      right_most_node.pre_node.keys.should==[5]
      right_most_node.pre_node.parent_node.keys.should==[3, 5]

      right_most_node.pre_node.pre_node.keys.should==[1, 3]
      right_most_node.pre_node.pre_node.parent_node.keys.should==[3, 5]
    end

    it "Insert Key Value 12" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      @btree.insert(1, "One");
      @btree.insert(7, "One");
      @btree.insert(3, "Three");
      @btree.insert(12, "Twelve");
      root_node=@btree.root_node

      root_node.keys.should == [5]
      right_most_node = root_node.infinity_node.infinity_node
      right_most_node.keys.should == [12]
      
      right_most_node.parent_node.keys.should == [8]
      right_most_node.parent_node.parent_node.keys.should == [5]

      right_most_node.pre_node.keys.should == [7, 8]
      right_most_node.pre_node.parent_node.keys.should == [8]
      right_most_node.pre_node.parent_node.parent_node.keys.should == [5]

      right_most_node.pre_node.pre_node.keys.should == [5]
      right_most_node.pre_node.pre_node.parent_node.keys.should == [3]
      right_most_node.pre_node.pre_node.parent_node.parent_node.keys.should == [5]

      right_most_node.pre_node.pre_node.pre_node.keys.should == [1, 3]
      right_most_node.pre_node.pre_node.pre_node.parent_node.keys.should == [3]
      right_most_node.pre_node.pre_node.pre_node.parent_node.parent_node.keys.should == [5]

    end

    it "Insert Key Value 9" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      @btree.insert(1, "One");
      @btree.insert(7, "One");
      @btree.insert(3, "Three");
      @btree.insert(12, "Twelve");
      @btree.insert(9, "Nine");
      root_node=@btree.root_node
      root_node.keys.should == [5]
      right_most_node = root_node.infinity_node.infinity_node
      right_most_node.keys.should == [9, 12]

      right_most_node.pre_node.keys.should == [7, 8]

      right_most_node.pre_node.pre_node.keys.should == [5]
      right_most_node.pre_node.pre_node.pre_node.keys.should == [1, 3]
    end

    it "Insert Key Value 6" do
      @btree.insert(5, "Five");
      @btree.insert(8, "Eight");
      @btree.insert(1, "One");
      @btree.insert(7, "One");
      @btree.insert(3, "Three");
      @btree.insert(12, "Twelve");
      @btree.insert(9, "Nine");
      @btree.insert(6, "Nine");
      root_node=@btree.root_node
      right_most_node = root_node.infinity_node.infinity_node
      right_most_node.keys.should == [9, 12]
      right_most_node.parent_node.keys.should == [7, 8]
      right_most_node.pre_node.keys.should == [8]
      right_most_node.pre_node.pre_node.keys.should == [6, 7]
      right_most_node.pre_node.pre_node.parent_node.keys.should == [7, 8]
      right_most_node.pre_node.pre_node.pre_node.keys.should == [5]
      right_most_node.pre_node.pre_node.pre_node.parent_node.keys.should == [3]
      right_most_node.pre_node.pre_node.pre_node.pre_node.keys.should == [1, 3]
      right_most_node.pre_node.pre_node.pre_node.pre_node.parent_node.keys.should == [3]
    end
  end
end
