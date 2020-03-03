module Fastlane
    module Actions
      class PrependChangelogAction < Action
        def self.run(params)
          changelog_path = params[:changelog_path] unless params[:changelog_path].to_s.empty?
          changelog_path = Helper::ChangelogHelper.ensure_changelog_exists(changelog_path)
  
          UI.message "Starting to prepend new section to '#{changelog_path}'"
  
          # Read & update file content
          file_content = ""
          found_identifying_section = false
  
          File.open(changelog_path, "r") do |file|
            line_separator = Helper::ChangelogHelper.get_line_separator(changelog_path)
            file.each_line do |line|
                if is_section_line(line) && !found_identifying_section
                    found_identifying_section = true
                    file_content.concat("#{params[:content]}#{("\n\n")}")
                end

                file_content.concat(line)
            end
          end
  
          # Write updated content to file
          changelog = File.open(changelog_path, "w")
          changelog.puts(file_content)
          changelog.close
          UI.success("Successfully updated #{changelog_path}")
        end
  
        def self.is_section_line(line)
          line =~ /\#{2}\s?\[.*\]/
        end
  
        #####################################################
        # @!group Documentation
        #####################################################
  
        def self.description
          "Prepends new content section to your project CHANGELOG.md file"
        end
  
        def self.details
          "Use this action to prepend a new changes section to your project CHANGELOG.md"
        end
  
        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :changelog_path,
                                         env_name: "FL_CHANGELOG_PATH",
                                         description: "The path to your project CHANGELOG.md",
                                         is_string: true,
                                         default_value: "./CHANGELOG.md",
                                         optional: true),
            FastlaneCore::ConfigItem.new(key: :content,
                                         env_name: "FL_UPDATE_CHANGELOG_UPDATED_SECTION_CONTENT",
                                         description: "The content to append",
                                         is_string: true,
                                         optional: false)
          ]
        end
  
        def self.authors
          ["pajapro"]
        end
  
        def self.is_supported?(platform)
          true
        end
      end
    end
  end
  