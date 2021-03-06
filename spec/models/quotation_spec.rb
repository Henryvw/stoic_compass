require 'rails_helper'

# Elements of Model Tests, According to Everyday RSpec 2019:
# 1. When instantiated with valid attributes, a model should be valid.
# 2. Data that fails validations should not be valid.
# 3. Instance methods perform as expected.
# 4. Class methods perform as expected.

# Matthias: FactoryBot, 3 core methods for building: create, build, and build_stubb. First use create to have most confidence. Build_stubb is less expensive as it does not save to the database. It creates a 'fake' id for the Model to talk to for associations etc.

describe Quotation, type: :model do
  let(:quotation) { FactoryBot.create(:quotation, :tag) }
  let(:tags) { quotation.tags }

  it 'has a valid factory' do
    # Given and When (In this case combined)
    fake_factory_bot_generated_quotation_object = FactoryBot.build(:quotation)
    fake_factory_bot_generated_tag_object = FactoryBot.build(:tag)
    # Then
    expect(fake_factory_bot_generated_quotation_object).to be_valid
    expect(fake_factory_bot_generated_tag_object).to be_valid
    expect(tags.first).to be_valid
  end

  # 1. When instantiated with valid attributes, a model should be valid
  # aka, testing the ability to construct a Ruby object along the lines of this model
  it 'creates a valid model object when given a title, passage and a published status' do
    quotation = Quotation.new(
      title: 'Nietzschelied',
      passage: 'Der Übermensch ist der Sinn der Erde. Euer Wille sage: der Übermensch sei der Sinn der Erde!',
      publish: true
    )
    expect(quotation).to be_valid
  end
  # 2. Data that fails validations should not be valid.
  # (Empty - bc there are no validations on this model)

  # 3 Instance methods perform as expected.
  # 3.1 Starting with Simple Automatic ActiveRecord ones, of returning saved attributes
  context 'Attributes - classic Active Record instance methods' do
    it 'returns a title' do
      quotation = FactoryBot.create(:quotation, title: 'Aurelius Dankenliste')
      expect(quotation.title).to eq 'Aurelius Dankenliste'
    end

    it 'returns a passage' do
      quotation = FactoryBot.create(:quotation, passage: 'Andenken meines Vaters')
      expect(quotation.passage).to include 'Andenken meines Vaters'
    end

    it 'returns boolean true/false whether published or not' do
      quotation = FactoryBot.create(:quotation, publish: true)
      expect(quotation.publish).to eq true
    end
  end

  # 3.2 - Now Going In-Depth Into More Complex, Custom Instance Methods
  describe '#tagged_with' do
    it '#tagged_with - when given a particular tag, returns all quotations attached to it in the database' do
      expect(Quotation.tagged_with(tags.first.name).first.title).to eq('Title')
    end
  end

  describe '#find_me_with' do
    it '#find_me_with - when given a LIST of tags, find all quotations attached to all of the tags in the database' do
      expect(Quotation.find_me_with(tags).first.title).to eq('Title')
    end
  end

  describe '#tag_list' do
    let(:quotation) { FactoryBot.create(:quotation, publish: true) }
    subject { quotation.tag_list }

    before do
      FactoryBot.create(:tag, name: 'Roman', quotations: [quotation])
      FactoryBot.create(:tag, name: 'Greek', quotations: [quotation])
      FactoryBot.create(:tag, name: 'Other')
    end

    it 'finds a list of all the TAGS associated with the particular given quotation' do
      expect(subject).to match('Roman')
      expect(subject).to match('Greek')
      expect(subject).to_not match('Other')
    end
  end

  describe '#tag_list=' do
    let(:quotation) { FactoryBot.create(:quotation, publish: true) }

    before do
      FactoryBot.create(:tag, quotations: [quotation])
    end

    context 'when a given tag already exist' do
      it 'assigns the tag_list' do
        quotation.tag_list = 'Phoenician Wisdom'
        quotation.tag_list = 'Phoenician Wisdom'
        expect(quotation.tag_list).to include('Phoenician Wisdom')
      end

      it 'reuses the previously existing tag' do
        quotation.tag_list = 'Phoenician Wisdom'
        quotation.tag_list = 'Phoenician Wisdom'
        expect(quotation.tag_list).to eq('Phoenician Wisdom')
      end
    end

    context 'when a given tag does not already exist' do
      it 'creates a new tag using the given name' do
        quotation.tag_list = 'Hellenistic Thoughts'
        expect(Tag.last).to have_attributes(name: 'Hellenistic Thoughts')
      end

      it 'assigns it to the given quotation' do
        quotation.tag_list = 'Amazing Stoics'
        expect(quotation.tag_list).to include('Amazing Stoics')
      end
    end
  end
end
