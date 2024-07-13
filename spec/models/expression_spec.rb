# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expression, type: :model do
  describe '#next' do
    context 'when user has not logged in' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

      it 'get next expression' do
        expect(first_expression_items[0].expression.next(nil)).to eq second_expression_items[0].expression
      end

      it 'get next expression even though the next id is missing' do
        second_expression_items[0].expression.destroy

        expect(first_expression_items[0].expression.next(nil)).to eq third_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(third_expression_items[0].expression.next(nil)).to eq nil
      end
    end

    context 'when user has logged in and url is home' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)

        expect(first_expression_items[0].expression.next(user)).to eq fourth_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(fourth_expression_items[0].expression.next(user)).to eq nil
      end
    end

    context 'when user has logged in and url is bookmarked_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)

        expect(first_expression_items[0].expression.next(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next(user)).to eq fourth_expression_items[0].expression
      end

      it 'get next expression when the bookmarking is created different order to expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.next(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next(user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.next(user)).to eq nil
      end
    end

    context 'when user has logged in and url is memorised_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)

        expect(first_expression_items[0].expression.next(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next(user)).to eq fourth_expression_items[0].expression
      end

      it 'get next expression when the memorising is created different order to expression' do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.next(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next(user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.next(user)).to eq nil
      end
    end
  end

  describe '#previous' do
    context 'when user has not logged in' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

      it 'get previous expression' do
        expect(second_expression_items[0].expression.previous(nil)).to eq first_expression_items[0].expression
      end

      it 'get previous expression even though the previous id is missing' do
        third_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
        second_expression_items[0].expression.destroy

        expect(third_expression_items[0].expression.previous(nil)).to eq first_expression_items[0].expression
      end
    end

    context 'when user has logged in and url is home' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.previous(user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(first_expression_items[0].expression.previous(user)).to eq nil
      end
    end

    context 'when user has logged in and url is bookmarked_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.previous(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.previous(user)).to eq first_expression_items[0].expression
      end

      it 'get previous expression when the bookmarking is created different order to expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.previous(user)).to eq third_expression_items[0].expression
        expect(fourth_expression_items[0].expression.previous(user)).to eq second_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)

        expect(second_expression_items[0].expression.previous(user)).to eq nil
      end
    end

    context 'when user has logged in and url is memorised_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.previous(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.previous(user)).to eq first_expression_items[0].expression
      end

      it 'get previous expression when the memorising is created different order to expression' do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.previous(user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.previous(user)).to eq fourth_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)

        expect(second_expression_items[0].expression.previous(user)).to eq nil
      end
    end
  end

  describe '.copy_initial_expressions!' do
    let!(:expression) { FactoryBot.create(:empty_note) }
    let!(:first_expression_item) { FactoryBot.create(:expression_item, expression:) }

    let!(:user) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item5, 2, expression: FactoryBot.create(:empty_note, user_id: user2.id)) }
    let!(:example) { FactoryBot.create(:example, expression_item: second_expression_items[0]) }

    before do
      FactoryBot.create(:expression_item2, expression:)
    end

    it 'check if expressions which user_id are nil are copied' do
      expect do
        described_class.copy_initial_expressions!(user)
      end.to change(described_class, :count).by(2).and change(ExpressionItem, :count).by(4).and change(Example, :count).by(2)
      expect(described_class.where('user_id = ?', user.id).count).to eq 2
      expect(ExpressionItem.where('content = ?', first_expression_item.content).count).to eq 2
      expect(Example.where('content = ?', example.content).count).to eq 1
    end
  end

  describe '.find_expressions_of_users_default_list' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
      FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
    end

    it 'return expressions that belongs to the user but does not belong to bookmarking and memorising' do
      expect(described_class.find_expressions_of_users_default_list(user).count).to eq 1
      expect(described_class.find_expressions_of_users_default_list(user)[0].expression_items[0].content).to eq second_expression_items[0].content
    end

    it 'return empty array when none expressions are found' do
      FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
      expect(described_class.find_expressions_of_users_default_list(user)).to eq []
    end
  end

  describe '#bookmarking?' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
    end

    it 'return true' do
      expect(first_expression_items[0].expression).to be_bookmarking
    end

    it 'return false' do
      expect(second_expression_items[0].expression).not_to be_bookmarking
    end
  end

  describe '#memorising?' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
    end

    it 'return ture' do
      expect(first_expression_items[0].expression).to be_memorising
    end

    it 'return false' do
      expect(second_expression_items[0].expression).not_to be_memorising
    end
  end

  describe '#destroy_expression_items' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 3, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    it 'check if old expression_item is deleted' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: first_expression_items[0].id,
              content: first_expression_items[0].content,
              explanation: first_expression_items[0].explanation,
              examples_attributes: { '0' => { content: 'This is an example.' } }
            },
            '1' => {
              id: first_expression_items[1].id,
              content: first_expression_items[1].content,
              explanation: first_expression_items[1].explanation,
              examples_attributes: { '0' => { content: 'This is an example.' } }
            },
            '2' => {
              id: first_expression_items[2].id,
              content: '',
              explanation: '',
              examples_attributes: { '0' => { content: '' }, '1' => { content: '' }, '2' => { content: '' } }
            }
          }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params =
        raw_params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }])
      expect { first_expression_items[0].expression.destroy_expression_items(params) }.to change(ExpressionItem, :count).by(-1)
    end
  end

  describe '#extract_current_examples' do
    it 'check examples of expression' do
      expression = described_class.find 1
      current_examples = [["I'm drying my clothes on the balcony."], ['The postman left my parcel on the veranda.']]
      expect(expression.extract_current_examples).to eq current_examples
    end
  end

  describe '.extract_new_examples' do
    it 'check new examples of expression' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: 1,
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { id: 1, content: "I'm drying my clothes on the balcony." }, '1' => { content: 'This is new' } }
            },
            '1' => {
              id: 2,
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { id: 2, content: 'The postman left my parcel on the veranda.' } }
            },
            '2' => {
              content: '',
              explanation: '',
              examples_attributes: { '0' => { content: '' }, '1' => { content: '' }, '2' => { content: '' } }
            }
          }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params =
        raw_params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }])
      new_examples = [["I'm drying my clothes on the balcony.", 'This is new'], ['The postman left my parcel on the veranda.'], []]
      expect(described_class.extract_new_examples(params)).to eq new_examples
    end
  end

  describe '#destroy_examples' do
    it 'check if old example is deleted' do
      expression = described_class.find 1
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: 1,
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { id: 1, content: "I'm drying my clothes on the balcony." } }
            },
            '1' => {
              id: 2,
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { id: 2, content: '' } }
            },
            '2' => {
              content: '',
              explanation: '',
              examples_attributes: { '0' => { content: '' }, '1' => { content: '' }, '2' => { content: '' } }
            }
          }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params =
        raw_params.require(:expression).permit(:id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }])
      expect { expression.destroy_examples(params) }.to change(Example, :count).by(-1)
    end
  end

  describe '#find_tags_object' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:tag) { FactoryBot.create(:tag) }

    it 'return a new tag object when the tag does not exist on database' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { content: "I'm drying my clothes on the balcony." } }
            },
            '1' => {
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { content: '' } }
            },
            '2' => { content: '', explanation: '', examples_attributes: { '0' => { content: '' }, '1' => { content: '' } } }
          },
          tags_attributes: { '0' => { name: 'new tag' } }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params = raw_params.require(:expression).permit(
        :id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }], tags_attributes: %i[id name]
      )
      expression = user.expressions.new(params)
      new_tag_object = expression.find_tags_object

      expect(new_tag_object[0].id).to eq nil
      expect(new_tag_object[0].name).to eq 'new tag'
      expect { new_tag_object[0].save }.to change(Tag, :count).by(1)
    end

    it 'return a tag object from database when the tag exist' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { content: "I'm drying my clothes on the balcony." } }
            },
            '1' => {
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { content: '' } }
            },
            '2' => { content: '', explanation: '', examples_attributes: { '0' => { content: '' }, '1' => { content: '' } } }
          },
          tags_attributes: { '0' => { name: tag.name } }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params = raw_params.require(:expression).permit(
        :id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }], tags_attributes: %i[id name]
      )
      expression = user.expressions.new(params)
      saved_tag_object = expression.find_tags_object

      expect(saved_tag_object[0].id).not_to eq nil
      expect(saved_tag_object[0].name).to eq 'test'
      expect { saved_tag_object[0].save }.to change(Tag, :count).by(0)
    end
  end

  describe '#destroy_taggings' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:tagging) { FactoryBot.create(:tagging, expression: first_expression_items[0].expression) }

    before do
      FactoryBot.create(:tagging2, expression: first_expression_items[0].expression)
    end

    it 'check if old tagging is deleted' do
      parameters = {
        expression: {
          note: '',
          expression_items_attributes: {
            '0' => {
              id: 1,
              content: 'balcony',
              explanation: '(noun) A platform on the side of a building, accessible from inside the building.',
              examples_attributes: { '0' => { id: 1, content: "I'm drying my clothes on the balcony." } }
            },
            '1' => {
              id: 2,
              content: 'veranda',
              explanation: '(noun) A covered area in front of an entrance, normally on the ground floor and generally quite ornate or fancy, with room to sit.',
              examples_attributes: { '0' => { id: 2, content: '' } }
            },
            '2' => {
              content: '',
              explanation: '',
              examples_attributes: { '0' => { content: '' }, '1' => { content: '' }, '2' => { content: '' } }
            }
          },
          tags_attributes: { '0' => { id: tagging.tag.id, name: tagging.tag.name } }
        }
      }
      raw_params = ActionController::Parameters.new(parameters)
      params = raw_params.require(:expression).permit(
        :id, :note, expression_items_attributes: [:id, :content, :explanation, { examples_attributes: %i[id content] }], tags_attributes: %i[id name]
      )
      expect { first_expression_items[0].expression.destroy_taggings(params) }.to change(Tagging, :count).by(-1)
    end
  end
end
