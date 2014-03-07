describe 'GroupedProgressEntry', ->
  describe 'grabIdsToEnd', ->
    dom = """
    <form>
          <input id="ei1" name="end_intervention[]" type="checkbox" value="1">
          <input id="ei2" name="end_intervention[]" type="checkbox" value="2" checked>
          </form>

          <div id="grouped_end_reasons"><form></form></div>

          """
    beforeEach ->
      setFixtures dom
      GroupedProgressEntry.grabIdsToEnd()
      @newcheckboxes = $('#grouped_end_reasons input[type="checkbox"]')


    it 'copies checkboxes', ->
      expect(@newcheckboxes.length).toEqual(2)

    it 'only copies once', ->
      GroupedProgressEntry.grabIdsToEnd()
      expect(@newcheckboxes.length).toEqual(2)

    it 'removes dom ids', ->
      expect($(@newcheckboxes)).toHaveId(undefined)

    it 'retains proper values', ->
      expect($(@newcheckboxes)).toBeHidden()
