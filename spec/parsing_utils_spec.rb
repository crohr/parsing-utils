require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ParsingUtils do
  it "should add the parser to the list of available parsers" do
    ParsingUtils::Parser.add(ParsingUtils::JSONParser, "application/json", "application/vnd.com.example.Object+json;level=1")
    ParsingUtils::Parser.available_parsers.should == [ParsingUtils::JSONParser]
    ParsingUtils::JSONParser.supported_mime_types.should == ["application/json", "application/vnd.com.example.Object+json;level=1"]
  end

  describe ParsingUtils::JSONParser do
    it "should correctly pretty generate an object" do
      object = {1=>2, 3=>4}
      ParsingUtils::JSONParser.dependencies
      ParsingUtils::JSONParser.dump(object, :format => :pretty).should == "{\n  \"1\": 2,\n  \"3\": 4\n}"
    end
    it "should correctly generate an object in the raw format" do
      object = {1=>2, 3=>4}
      ParsingUtils::JSONParser.dependencies
      ParsingUtils::JSONParser.dump(object).should == "{\"1\":2,\"3\":4}"
    end
    it "should correctly generate an object having a custom to_json function" do
      class Foo
        def to_json(*a)
          "{\"1\":3,\"3\":5}"
        end
      end
      ParsingUtils::JSONParser.dependencies
      ParsingUtils::JSONParser.dump(Foo.new).should == "{\"1\":3,\"3\":5}"
    end
  end
  
  describe ParsingUtils::IdentityParser do
    it "should behave like a parser" do
      ParsingUtils::IdentityParser.default_mime_type.should == 'text/plain'
      ParsingUtils::IdentityParser.should respond_to(:dump)
      ParsingUtils::IdentityParser.should respond_to(:load)
      ParsingUtils::IdentityParser.should respond_to(:dependencies)
      ParsingUtils::IdentityParser.should respond_to(:supported_mime_types)
      ParsingUtils::IdentityParser.should respond_to(:supported_mime_types=)
    end
    it "behave such as the dumped object be the same as original object" do
      object = mock("object")
      ParsingUtils::IdentityParser.dump(object).should == object
    end
    it "behave such as the loaded object be the same as original object" do
      object = mock("object")
      ParsingUtils::IdentityParser.load(object).should == object
    end
  end
end
