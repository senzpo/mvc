# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Api::V1::Projects::BaseSerializer' do
  let(:user_attributes) { { email: 'some@example.com', password_hash: 'secret', salt: 'aaa' } }
  let(:user_id) { ApplicationRepository::DB[:users].insert(user_attributes) }
  let(:project_id) { ApplicationRepository::DB[:projects].insert(project_attributes.merge(user_id: user_id)) }
  let(:user) { UserRepository.find(id: user_id) }
  let(:project_attributes) { { title: 'Test project', description: 'My very best description' } }
  let(:project) { ProjectRepository.find(id: project_id) }

  it 'serialize by default' do
    result = Api::V1::Projects::BaseSerializer.new(project).serialize
    expect(result).to eq(
      {
        data: {
          attributes: {
            description: project.description,
            title: project.title
          },
          id: project.id.to_s,
          type: 'project'
        }
      }
    )
  end

  it 'serialize with custom id, type, field' do
    custom_serializer = Class.new(Api::V1::Projects::BaseSerializer) do
      type :some_custom_type
      id do |object|
        object.id.to_s * 2
      end

      def description
        'Custom description'
      end
    end
    result = custom_serializer.new(project).serialize
    expect(result).to eq(
      {
        data: {
          attributes: {
            description: 'Custom description',
            title: project.title
          },
          id: "#{project.id}#{project.id}",
          type: 'some_custom_type'
        }
      }
    )
  end

  it 'serialize with links' do
    custom_serializer = Class.new(Api::V1::Projects::BaseSerializer) do
      links do |object|
        {
          self: "/api/v1/projects/#{object.id}",
          related: "/api/v1/projects/#{object.id}/steps"
        }
      end
    end
    result = custom_serializer.new(project).serialize
    expect(result).to eq(
      {
        data: {
          attributes: {
            description: project.description,
            title: project.title
          },
          links: {
            self: "/api/v1/projects/#{project.id}",
            related: "/api/v1/projects/#{project.id}/steps"
          },
          id: project.id.to_s,
          type: 'project'
        }
      }
    )
  end

  it 'serialize with relationships' do
    user_serializer = Class.new(ApplicationSerializer) do
      attributes :email
    end
    custom_serializer = Class.new(Api::V1::Projects::BaseSerializer) do
      has_one :author do |object|
        user_serializer.new(object.author).serialize
      end
    end
    result = custom_serializer.new(project, include: [:author]).serialize
    expect(result).to eq(
      {
        data: {
          attributes: {
            description: project.description,
            title: project.title
          },
          id: project.id.to_s,
          type: 'project',
          relationships: {
            author: {
              data: {
                id: user_id.to_s,
                type: 'user'
              }
            }
          },
          included: [
            {
              type: 'user',
              id: user.id.to_s,
              attributes: {
                email: user.email
              }
            }
          ]
        }
      }
    )
  end

  it 'serialize collection by default' do
    result = Api::V1::Projects::BaseSerializer.new([project]).serialize
    expect(result).to eq(
      {
        data: [{
          attributes: {
            description: project.description,
            title: project.title
          },
          id: project.id.to_s,
          type: 'project'
        }]
      }
    )
  end
end
