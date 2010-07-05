require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe DB::Core::Common do
  context "binary search" do
    before(:each) do
      @arr=[]
      (100..200).each {|i| @arr << i }
    end
    it "should return nil when search term is not found" do
      r=DB::Core::Common.binary_search(@arr, 500, 0, @arr.length-1)
      r.should == nil
    end

    it "should return last element quickly compared to linear search" do
      _start = Time.now
      r=DB::Core::Common.binary_search(@arr, @arr[-1], 0, @arr.length-1)
      r.should == @arr[-1]
      _end = Time.now
      binary_time=_end - _start

      _start = Time.now
      @arr.select {|i| i == @arr[-1]}
      _end = Time.now
      linear_time=_end - _start

#      puts "binary_time #{binary_time}, linear_time #{linear_time} factor #{linear_time/binary_time}"
      linear_time.should > binary_time
    end

    it "should support block" do
      @arr=[]
      (100..200).each {|i| @arr << [i] }
      r=DB::Core::Common.binary_search(@arr, @arr[-1][0], 0, @arr.length-1) {|ele| ele[0]}
      r[0].should == @arr[-1][0]
    end

  end
end