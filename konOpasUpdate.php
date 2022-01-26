<?php
if ($argc != 4) {
  echo "Update date on KonOpas JSON file.\n";
  echo "Call as follows:\n";
  echo "php konOpasUpdate.php YYYY-MM-DD oldfile.json newfile.json\n";
  exit(0);
}

function extractJson($data)
{
  $chars = mb_str_split($data, 1, 'UTF-8');
  $inEntity = false;
  $arrayLevel = 0;
  $objectLevel = 0;
  $inLineComment = false;
  $inBlockComment = false;
  $inSingleQuote = false;
  $inDoubleQuote = false;
  $jsonEntities = [];
  $prevChar = null;
  $json = "";

  $countChars = count($chars);
  for ($curPos = 0; $curPos < $countChars; $curPos++) {
    $curChar = $chars[$curPos];
    if ($prevChar != "\\") {
      switch ($curChar) {
        case "/":
          $nextChar = $chars[$curPos + 1];
          if (
          $nextChar == "/" &&
          !$inBlockComment &&
          !$inSingleQuote &&
          !$inDoubleQuote
          ) {
            $inLineComment = true;
          }
          if (
          $nextChar == "*" &&
          !$inLineComment &&
          !$inSingleQuote &&
          !$inDoubleQuote
          ) {
            $inBlockComment = true;
          }
          break;
        case "\n":
        case "\r":
          $inLineComment = false;
          break;
        case "'":
          if ($inSingleQuote) {
            // In string, so closing quote.
            $inSingleQuote = false;
            break;
          }
          if (!$inDoubleQuote)
            $inSingleQuote = true; // Opening quote.
          break;
        case '"':
          if ($inDoubleQuote) {
            // In string already, so closing quote.
            $inDoubleQuote = false;
            break;
          }
          if (!$inSingleQuote)
            $inDoubleQuote = true; // Opening quote.
          break;
        case "{":
          if (!$inSingleQuote && !$inDoubleQuote) {
            // Make sure not in string.
            if (!$inEntity) {
              // If start of entity, note position.
              $inEntity = true;
            }
            $objectLevel++; // Increase object level to allow for nested objects.
          }
          break;
        case "}":
          if (!$inSingleQuote && !$inDoubleQuote) {
            $objectLevel--;
          }
          break;
        case "[":
          if (!$inSingleQuote && !$inDoubleQuote) {
            // Make sure not in string.
            if (!$inEntity) {
              // If start of entity, note position.
              $inEntity = true;
            }
            $arrayLevel++; // Increase array level to allow for nested arrays.
          }
          break;
        case "]":
          if (!$inSingleQuote && !$inDoubleQuote) {
            $arrayLevel--; // Decrease array level.
          }
          break;
        default:
          break;
      }
    }
    // If we're inside an entity, add character (unless inside comment), then check if end of entity.
    if ($inEntity && !$inLineComment && !$inBlockComment) {
      $json .= $curChar;
      if ($objectLevel === 0 && $arrayLevel === 0) {
        // No longer in entity, so push to entities array, and reset json string.
        $jsonEntities[] = json_decode($json);
        $json = "";
        $inEntity = false;
      }
    }
    // We need to process end comment after add char to json, so the closing "/" doesn't get added.
    if (
    $prevChar == "*" &&
    $curChar == "/" &&
    $inBlockComment &&
    !$inSingleQuote &&
    !$inDoubleQuote
    ) {
      $inBlockComment = false;
    }
    $prevChar = $curChar;
  }

  return $jsonEntities;
}

function findOldestDate($program)
{
  $oldest = "9999-99-99"; // Set to an impossibly far future date.
  foreach ($program as $item) {
    if ($item->date < $oldest)
      $oldest = $item->date;
  }
  return $oldest;
}

function addOffsetToDates($program, $offset)
{
  foreach ($program as $item) {
    $oldTime = strtotime($item->date);
    $item->date = gmdate("Y-m-d", $oldTime + $offset);
  }
  return "var program = " . json_encode($program) . ";\n";
}

// Convert new start date to timestamp.
$newStartDate = strtotime($argv[1]);

// Open the input file and get the oldest date.
$inputData = file_get_contents($argv[2]);
$entities = extractJson($inputData);
$oldest = strtotime(findOldestDate($entities[0]));
$offset = $newStartDate - $oldest;

$program = addOffsetToDates($entities[0], $offset);

$file = fopen($argv[3], "w");
fwrite($file, $program);

if (count($entities) > 1) {
  $people = "var people = " . json_encode($entities[1]) . ";\n";
  fwrite($file, $people);
}
fclose($file);
