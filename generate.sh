#!/bin/bash

# Define the package name for your project
PACKAGE_NAME="island_gen_flutter"

# Check if --no-cache flag is set
NO_CACHE=false
for arg in "$@"; do
  if [ "$arg" == "--no-cache" ]; then
    NO_CACHE=true
    break
  fi
done


# Step 0: Restore 'part' directives to local paths in source files
echo "Restoring 'part' directives to local paths in source files..."
find lib -type f -name "*.dart" ! -path "lib/generated/*" | while read -r file; do
  filename=$(basename "$file" .dart)

  # Update 'part' directives to local files
  sed -i '' -E "s|part 'package:$PACKAGE_NAME/generated/.*/$filename\.freezed\.dart';|part '$filename.freezed.dart';|g" "$file"
  sed -i '' -E "s|part 'package:$PACKAGE_NAME/generated/.*/$filename\.g\.dart';|part '$filename.g.dart';|g" "$file"
  sed -i '' -E "s|part 'package:$PACKAGE_NAME/generated/.*/$filename\.riverpod\.dart';|part '$filename.riverpod.dart';|g" "$file"
done

# Step 1: Clean the build cache if --no-cache is set
if [ "$NO_CACHE" == true ]; then
  echo "Cleaning build cache..."
  dart run build_runner clean
fi


# Step 2: Run the build_runner to generate files
echo "Running build_runner..."
flutter pub run build_runner build
# dart run build_runner build --delete-conflicting-outputs --enable-experiment=native-assets

# Step 3: Define the target directory for generated files
GENERATED_DIR="lib/generated"

# Step 3.5: Delete existing files in the generated directory
echo "Clearing existing generated files..."
rm -rf "$GENERATED_DIR"/*.dart

# Step 4: Find and move generated files while preserving directory structure
echo "Finding and moving generated files..."
find lib -type f \( -name "*.freezed.dart" -o -name "*.g.dart" -o -name "*.riverpod.dart" \) ! -path "lib/generated/*" | while read -r generated_file; do
  base_filename=$(basename "$generated_file" .dart)

  # Remove the generated file suffix to get the original base name
  if [[ "$base_filename" == *.freezed ]]; then
    original_basename="${base_filename%.freezed}"
  elif [[ "$base_filename" == *.g ]]; then
    original_basename="${base_filename%.g}"
  elif [[ "$base_filename" == *.riverpod ]]; then
    original_basename="${base_filename%.riverpod}"
  else
    echo "Unknown generated file type: $base_filename"
    continue
  fi

  dirpath=$(dirname "$generated_file")
  relative_dirpath=${dirpath#lib/}
  original_file="$dirpath/$original_basename.dart"

  if [ ! -f "$original_file" ]; then
    echo "Original file not found for $generated_file"
    continue
  fi

  # Convert the file path to package import format
  package_import=$(echo "$original_file" | sed "s|^lib/|package:$PACKAGE_NAME/|")

  # Update the 'part of' directive in the generated file
  sed -i '' -E "s|part of '.*';|part of '$package_import';|g" "$generated_file"

  # Move the generated file to the generated directory, preserving relative path
  target_dir="$GENERATED_DIR/$relative_dirpath"
  mkdir -p "$target_dir"
  mv -f "$generated_file" "$target_dir/"
done

# Verify if the files were moved
echo "Contents of lib/generated directory:"
find "$GENERATED_DIR" -type f

# Step 5: Update 'part' directives in source files to point to generated directory
echo "Updating 'part' directives in source files..."
find lib -type f -name "*.dart" ! -path "lib/generated/*" | while read -r file; do
  filename=$(basename "$file" .dart)
  dirpath=$(dirname "$file")
  relative_dirpath=${dirpath#lib/}

  # Escape for sed
  escaped_relative_dirpath=$(echo "$relative_dirpath" | sed 's/[&/\]/\\&/g')

  # Update 'part' directives with correct package path
  sed -i '' -E "s|part '$filename\.freezed\.dart';|part 'package:$PACKAGE_NAME/generated/$escaped_relative_dirpath/$filename.freezed.dart';|g" "$file"
  sed -i '' -E "s|part '$filename\.g\.dart';|part 'package:$PACKAGE_NAME/generated/$escaped_relative_dirpath/$filename.g.dart';|g" "$file"
  sed -i '' -E "s|part '$filename\.riverpod\.dart';|part 'package:$PACKAGE_NAME/generated/$escaped_relative_dirpath/$filename.riverpod.dart';|g" "$file"
done


echo "Build and move completed successfully!"