import gmaps
from IPython.display import display
import ipywidgets as widgets

class AcledExplorer(object):

    def __init__(self, df):
        self._df = df
        self._heatmap = None
        self._slider = None
        initial_month = min(self._df['month'])

        map_figure = self._render_map(initial_month)
        controls = self._render_controls(initial_month)
        self._container = widgets.VBox([controls, map_figure])

    def render(self):
        display(self._container)

    def _on_month_change(self, change):
        month = self._slider.value
        self._heatmap.locations = self._locations_for_month(month)
        self._total_box.value = self._total_casualties_text_for_month(month)
        return self._container

    def _render_map(self, initial_month):
        fig = gmaps.figure(map_type='HYBRID')
        self._heatmap = gmaps.heatmap_layer(
            self._locations_for_month(initial_month)
        )
        fig.add_layer(self._heatmap)
        return fig

    def _render_controls(self, initial_month):
        self._slider = widgets.IntSlider(
            value=initial_month,
            min=min(self._df['month']),
            max=max(self._df['month']),
            description='Months 2018',
            continuous_update=False
        )
        self._total_box = widgets.Label(
            value=self._total_casualties_text_for_month(initial_month)
        )
        self._slider.observe(self._on_month_change, names='value')
        controls = widgets.HBox(
            [self._slider, self._total_box],
            layout={'justify_content': 'space-between'}
        )
        return controls

    def _locations_for_month(self, month):
        return self._df[self._df['month'] == month][['lat', 'long']]

    def _total_casualties_for_month(self, month):
        return int(self._df[self._df['month'] == month]['month'].count())

    def _total_casualties_text_for_month(self, month):
        return '{} Floods Predicted'.format(self._total_casualties_for_month(month))

