# encoding: utf-8

module Backup
  module Syncer
    class S3 < Cloud

      ##
      # Amazon Simple Storage Service (S3) Credentials
      attr_accessor :access_key_id, :secret_access_key

      ##
      # The S3 bucket to store files to
      attr_accessor :bucket

      ##
      # The AWS region of the specified S3 bucket
      attr_accessor :region

      private

      ##
      # Established and creates a new Fog storage object for S3.
      def connection
        @connection ||= Fog::Storage.new(
          :provider              => provider,
          :aws_access_key_id     => access_key_id,
          :aws_secret_access_key => secret_access_key,
          :region                => region
        )
      end

      ##
      # Creates a new @repository_object (bucket). Fetches it from S3
      # if it already exists, otherwise it will create it first and fetch use that instead.
      def repository_object
        @repository_object ||= connection.directories.get(bucket) ||
          connection.directories.create(:key => bucket, :location => region)
      end

      ##
      # This is the provider that Fog uses for the Cloud Files
      def provider
        "AWS"
      end
    end
  end
end
