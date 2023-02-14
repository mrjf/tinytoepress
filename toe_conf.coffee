austin =
  title: 'Austin Nights'
  slug: 'Austin_Nights'
  author: 'Herocious'
  htmlFile: 'resources/books/Austin_Nights/austin_converted.html'
  pagesFile: 'resources/books/Austin_Nights/Austin_Nights.pages.json'
  frontMatter: ['cover', 'title']

mosq = 
  title: 'The Mosquito Song'
  slug: 'The_Mosquito_Song'
  author: 'M. L. Kennedy'
  htmlFile: 'resources/books/The_Mosquito_Song/The_Mosquito_Song.html'
  pagesFile: 'resources/books/The_Mosquito_Song/The_Mosquito_Song.pages.json'
  frontMatter: ['cover', 'title']

scorpio = 
  title: 'Heart of Scorpio'
  slug: 'Heart_of_Scorpio'
  author: 'Joseph Avski'
  translator: 'Mark McGraw'
  htmlFile: 'resources/books/Heart_of_Scorpio/Heart_of_Scorpio.html'
  pagesFile: 'resources/books/Heart_of_Scorpio/Heart_of_Scorpio.pages.json'
  frontMatter: ['cover', 'title']

module.exports =
  libraryName: 'TOE'

  books:
    [austin, mosq, scorpio]
      