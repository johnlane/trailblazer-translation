require 'test_helper'

require_dependency 'test/operations'

class I18nTest < MiniTest::Spec

  EN = { 'top' => 'top',
         'test.form.text1' => 'test form text',
         'test.text2' => 'test text',
         'test.text3' => 'test text with %{var} inserted'
  }

  I18n.backend = I18n::Backend::KeyValue.new({})
  I18n.backend.store_translations(:en, EN, escape: false)

  it { Test::Form.class.must_equal Class } 

  describe "operation" do

    it "has a scope based on class name" do
      Test::Form.new({}).scope.must_equal 'test.form'
      Test::Form.new({}).contract.scope.must_equal 'test.form.form'
      Reform::Form.new({}).scope.must_equal 'reform.form'
    end

    it "translates a absolute key" do
      Test::Form.new({}).t('top').must_equal 'top'
      Test::Form.new({}).contract.t('top').must_equal 'top'
    end

    it "translates a relative key" do
      Test::Form.new({}).t('.text1').must_equal 'test form text'
      Test::Form.new({}).contract.t('.text1').must_equal 'test form text'
    end

    it "translates a relative key by iterating" do
      Test::Form.new({}).t('.text2', iterate: false).must_match /missing/
      Test::Form.new({}).t('.text2').must_equal 'test text'
      Test::Form.new({}).contract.t('.text2', iterate: false).must_match /missing/
      Test::Form.new({}).contract.t('.text2').must_equal 'test text'
    end

    it "can iterate to the top level" do
      Test::Form.new({}).t('.top', iterate: false).must_match /missing/
      Test::Form.new({}).t('.top').must_equal 'top'
      Test::Form.new({}).contract.t('.top', iterate: false).must_match /missing/
      Test::Form.new({}).contract.t('.top').must_equal 'top'
    end

    it "accepts variables" do
      Test::Form.new({}).t('.text3', var: 'word').must_match 'test text with word inserted'
    end

    it "can raise a 'translation not found' exception" do
      e = lambda {Test::Form.new({}).t('nowhere', raise:true)}.must_raise I18n::MissingTranslationData
      e.message.must_equal 'translation missing: en.nowhere'
    end

  end


end
