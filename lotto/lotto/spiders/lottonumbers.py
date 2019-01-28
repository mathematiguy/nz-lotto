# -*- coding: utf-8 -*-
import scrapy
import logging


class LottonumbersSpider(scrapy.Spider):
    name = 'lottonumbers'
    allowed_domains = ['lottoresults.co.nz']
    start_urls = ['http://lottoresults.co.nz/lotto/archive']

    def parse(self, response):
    	month_urls = response.xpath("//div[@class='row']/div/div/div/ul/li/a/@href").extract() 
    	for url in month_urls:
    		next_url = response.urljoin(url)
    		yield scrapy.Request(next_url, callback = self.parse_month_results)

    def parse_month_results(self, response):
        result_cards = response.xpath('//div[@class="result-card"]')
        for result_card in result_cards:
            result_url = result_card.xpath("div/h2/a/@href").extract()
            result_url = response.urljoin(result_url[0])
            logging.info("Found url %s" %result_url)
            yield scrapy.Request(result_url, callback = self.parse_result_page)

    def parse_result_page(self, response):

        logging.info("Arrived at %s" %response.url)
        result_dict = {'date': response.url.rsplit("/", 1)[-1]}
        
        # Get the main draw results
        *main_draw, bonus = response.xpath('//ol[@class="draw-result"]/li/text()').extract()
        for i, ball in enumerate(main_draw):
        	result_dict['ball_%d' %(i + 1)] = ball
        result_dict['bonus'] = bonus
        
        # Get the sub draw results
        sub_draws = response.xpath('//ol[@class="draw-result draw-result--sub"]')
        for sub_draw in sub_draws:
            draw_label = sub_draw.xpath("li/img/@alt").extract()
            result = sub_draw.xpath("li[contains(@class, 'draw-result__ball')]/text()").extract()
            if "NZ Powerball Logo" in draw_label:
                result_dict['powerball'] = result[0]
            elif "NZ Strike! Logo" in draw_label:
            	for i, ball in enumerate(result):
            		result_dict['strike_%s' %(i + 1)] = ball

        # Read the draw details
        draw_details = response.xpath('//li[@class="draw-details-meta__title"]')
        for draw_detail in draw_details:
            detail_label = draw_detail.xpath('text()').extract()[0].strip()
            detail_text = draw_detail.xpath('span/text()').extract()[0]
            draw_details = response.xpath('//li[@class="draw-details-meta__title"]').extract()
            if 'Draw number:' in detail_label:
                result_dict['draw_number'] = detail_text
            elif 'Total Prize Pool:' in detail_label:
                result_dict['total_prize_pool'] = detail_text
            elif 'Number of Winners:' in detail_label:
                result_dict['number_of_winners'] = detail_text
            elif 'Average Prize per Winner:' in detail_label:
                result_dict['average_prize_per_winner'] = detail_text

        table_cells = response.xpath('//table[@class="result-details-table"]/tbody/tr/td')
        table_cols = ['division', 'matches', 'winners', 'prize', 'payout']
        results_table = []
        current_row = []
        for cell_num, cell in enumerate(table_cells):

            cell_text = cell.xpath('text()').extract()
            payout_text = cell.xpath("ul/li/span/text()").extract()
            match_text = cell.xpath("span/text()").extract()
            if len(match_text) > 0:
                current_row.append(match_text[0])
            elif len(payout_text) > 0:
                current_row.append(payout_text[0])
            elif len([t for t in cell_text if len(t.strip()) > 0]):
                current_row.append(cell_text[0])

            if len(current_row) == 5:
                results_table.append(dict(zip(table_cols, current_row)))
                current_row = []

        result_dict['results_table'] = results_table

        yield result_dict
