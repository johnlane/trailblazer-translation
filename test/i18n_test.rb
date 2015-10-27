require 'test_helper'

require_dependency 'test/operations'

class I18nTest < MiniTest::Spec

  EN = { 'top' => 'top',
         'test.form.text1' => 'test form text',
         'test.text2' => 'test text',
         'test.text3' => 'test text with %{var} inserted',
         'test.nested.text' => 'nested text'
  }

  I18n.backend = I18n::Backend::KeyValue.new({})
  I18n.backend.store_translations(:en, EN, escape: false)

  it { Test::Form.class.must_equal Class } 

  class Test::Cell
    class Nested < Cell::Concept; end
  end

  it { Test::Cell.class.must_equal Class }
  it { Test::Cell.to_s.must_equal "Test::Cell" }
  it { Test::Cell::Nested.class.must_equal Class }
  it { Test::Cell::Nested.to_s.must_equal "Test::Cell::Nested" }

  describe "operation" do

    it "has a scope based on class name" do
      Test::Form.new({}).scope.must_equal 'test.form'
      Test::Form.new({}).contract.scope.must_equal 'test.form.form'
      Reform::Form.new({}).scope.must_equal 'reform.form'
      Test::Cell.new({}).scope.must_equal 'test.cell'

      Test::Form.scope.must_equal 'test.form'
      Test::Form.contract.scope.must_equal 'test.form.form'
      Reform::Form.scope.must_equal 'reform.form'
      Test::Cell.scope.must_equal 'test.cell'
    end

    it "translates a absolute key" do
      Test::Form.new({}).t('top').must_equal 'top'
      Test::Form.new({}).contract.t('top').must_equal 'top'

      Test::Form.t('top').must_equal 'top'
      Test::Form.contract.t('top').must_equal 'top'
    end

    it "translates a relative key" do
      Test::Form.new({}).t('.text1').must_equal 'test form text'
      Test::Form.new({}).contract.t('.text1').must_equal 'test form text'

      Test::Form.t('.text1').must_equal 'test form text'
      Test::Form.contract.t('.text1').must_equal 'test form text'
    end

    it "translates a relative key by iterating" do
      Test::Form.new({}).t('.text2', iterate: false).must_match /missing/
      Test::Form.new({}).t('.text2').must_equal 'test text'
      Test::Form.new({}).contract.t('.text2', iterate: false).must_match /missing/
      Test::Form.new({}).contract.t('.text2').must_equal 'test text'

      Test::Form.t('.text2', iterate: false).must_match /missing/
      Test::Form.t('.text2').must_equal 'test text'
      Test::Form.contract.t('.text2', iterate: false).must_match /missing/
      Test::Form.contract.t('.text2').must_equal 'test text'
    end

    it "can iterate to the top level" do
      Test::Form.new({}).t('.top', iterate: false).must_match /missing/
      Test::Form.new({}).t('.top').must_equal 'top'
      Test::Form.new({}).contract.t('.top', iterate: false).must_match /missing/
      Test::Form.new({}).contract.t('.top').must_equal 'top'

      Test::Form.t('.top', iterate: false).must_match /missing/
      Test::Form.t('.top').must_equal 'top'
      Test::Form.contract.t('.top', iterate: false).must_match /missing/
      Test::Form.contract.t('.top').must_equal 'top'
    end

    it "accepts variables" do
      Test::Form.new({}).t('.text3', var: 'word').must_match 'test text with word inserted'

      Test::Form.t('.text3', var: 'word').must_match 'test text with word inserted'
    end

    it "can raise a 'translation not found' exception" do
      e = lambda {Test::Form.new({}).t('nowhere', raise:true)}.must_raise I18n::MissingTranslationData
      e.message.must_equal 'translation missing: en.nowhere'

      e = lambda {Test::Form.t('nowhere', raise:true)}.must_raise I18n::MissingTranslationData
      e.message.must_equal 'translation missing: en.nowhere'
    end

    it "removes 'cell' path component from a relative key" do
      Test::Cell::Nested.new({}).scope.must_equal 'test.cell.nested'
      Test::Cell::Nested.new({}).t('.text').must_equal 'nested text'

      Test::Cell::Nested.scope.must_equal 'test.cell.nested'
      Test::Cell::Nested.t('.text').must_equal 'nested text'
    end

  end


end
