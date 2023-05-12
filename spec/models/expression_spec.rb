# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Expression, type: :model do
  describe '#next' do
    context 'when user has not logged in' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

      it 'get next expression' do
        expect(first_expression_items[0].expression.next('/', nil)).to eq second_expression_items[0].expression
      end

      it 'get next expression even though the next id is missing' do
        second_expression_items[0].expression.destroy

        expect(first_expression_items[0].expression.next('/', nil)).to eq third_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(third_expression_items[0].expression.next('/', nil)).to eq nil
      end
    end

    context 'when user has logged in and first argument is root' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)

        expect(first_expression_items[0].expression.next('/', user)).to eq fourth_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(fourth_expression_items[0].expression.next('/', user)).to eq nil
      end
    end

    context 'when user has logged in and first argument is bookmarked_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)

        expect(first_expression_items[0].expression.next('/bookmarked_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next('/bookmarked_expressions', user)).to eq fourth_expression_items[0].expression
      end

      it 'get next expression when the bookmark is created different order to expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.next('/bookmarked_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next('/bookmarked_expressions', user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.next('/bookmarked_expressions', user)).to eq nil
      end
    end

    context 'when user has logged in and first argument is memorised_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)

        expect(first_expression_items[0].expression.next('/memorised_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next('/memorised_expressions', user)).to eq fourth_expression_items[0].expression
      end

      it 'get next expression when the memorised expression is created different order to expression' do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.next('/memorised_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.next('/memorised_expressions', user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.next('/memorised_expressions', user)).to eq nil
      end
    end

    context 'when first argument is nil and second argument is record of user' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get next expression' do
        expect(first_expression_items[0].expression.next(nil, user)).to eq second_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(second_expression_items[0].expression.next(nil, user)).to eq nil
      end
    end

    context 'when first argument and second argument are nil' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

      it 'get next expression' do
        expect(first_expression_items[0].expression.next(nil, nil)).to eq third_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(third_expression_items[0].expression.next(nil, nil)).to eq nil
      end
    end
  end

  describe '#previous' do
    context 'when user has not logged in' do
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

      it 'get previous expression' do
        expect(second_expression_items[0].expression.previous('/', nil)).to eq first_expression_items[0].expression
      end

      it 'get previous expression even though the previous id is missing' do
        third_expression_items = FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note))
        second_expression_items[0].expression.destroy

        expect(third_expression_items[0].expression.previous('/', nil)).to eq first_expression_items[0].expression
      end
    end

    context 'when user has logged in and first argument is root' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.previous('/', user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(first_expression_items[0].expression.previous('/', user)).to eq nil
      end
    end

    context 'when user has logged in and first argument is bookmarked_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.previous('/bookmarked_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.previous('/bookmarked_expressions', user)).to eq first_expression_items[0].expression
      end

      it 'get previous expression when the bookmark is created different order to expression' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.previous('/bookmarked_expressions', user)).to eq third_expression_items[0].expression
        expect(fourth_expression_items[0].expression.previous('/bookmarked_expressions', user)).to eq second_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)

        expect(second_expression_items[0].expression.previous('/bookmarked_expressions', user)).to eq nil
      end
    end

    context 'when user has logged in and first argument is memorised_expressions' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:fourth_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)

        expect(fourth_expression_items[0].expression.previous('/memorised_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.previous('/memorised_expressions', user)).to eq first_expression_items[0].expression
      end

      it 'get previous expression when the bookmark is created different order to expression' do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: fourth_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
        FactoryBot.create(:memorising, user:, expression: first_expression_items[0].expression)

        expect(first_expression_items[0].expression.previous('/memorised_expressions', user)).to eq third_expression_items[0].expression
        expect(third_expression_items[0].expression.previous('/memorised_expressions', user)).to eq fourth_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        FactoryBot.create(:memorising, user:, expression: second_expression_items[0].expression)

        expect(second_expression_items[0].expression.previous('/memorised_expressions', user)).to eq nil
      end
    end

    context 'when first argument is nil and second argument is record of user' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

      it 'get previous expression' do
        expect(second_expression_items[0].expression.previous(nil, user)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expect(first_expression_items[0].expression.previous(nil, user)).to eq nil
      end
    end

    context 'when first argument and second argument are nil' do
      let!(:user) { FactoryBot.create(:user) }
      let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }
      let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note, user_id: user.id)) }
      let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:note)) }

      it 'get previous expression' do
        expect(third_expression_items[0].expression.previous(nil, nil)).to eq first_expression_items[0].expression
      end

      it 'return nil if no record is found' do
        expression = ExpressionItem.find_by(content: 'balcony').expression
        expect(expression.previous(nil, nil)).to eq nil
      end
    end
  end

  describe '.copy_initial_expressions!' do
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user2.id)) }
    let!(:example) { FactoryBot.create(:example, expression_item: second_expression_items[0]) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }

    it 'check if expressions which user_id are nil are copied' do
      expect do
        described_class.copy_initial_expressions!(user.id)
      end.to change(described_class, :count).by(2).and change(ExpressionItem, :count).by(4).and change(Example, :count).by(2)
      expect(described_class.where('user_id = ?', user.id).count).to eq 2
      expect(ExpressionItem.where('content = ?', first_expression_items[0].content).count).to eq 2
      expect(Example.where('content = ?', example.content).count).to eq 1
    end
  end

  describe '.find_expressions_of_users_main_list' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:first_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:second_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }
    let!(:third_expression_items) { FactoryBot.create_list(:expression_item, 2, expression: FactoryBot.create(:empty_note, user_id: user.id)) }

    before do
      FactoryBot.create(:bookmarking, user:, expression: first_expression_items[0].expression)
      FactoryBot.create(:memorising, user:, expression: third_expression_items[0].expression)
    end

    it 'return expressions that belongs to the user but does not belong to bookmarking and memorising' do
      expect(described_class.find_expressions_of_users_main_list(user.id).count).to eq 1
      expect(described_class.find_expressions_of_users_main_list(user.id)[0].expression_items[0].content).to eq second_expression_items[0].content
    end

    it 'return empty array when none expressions are found' do
      FactoryBot.create(:bookmarking, user:, expression: second_expression_items[0].expression)
      expect(described_class.find_expressions_of_users_main_list(user.id)).to eq []
    end
  end
end
